/**
 * Copyright (C) 2010 Sopra Steria Group (movalys.support@soprasteria.com)
 *
 * This file is part of Movalys MDK.
 * Movalys MDK is free software: you can redistribute it and/or modify
 * it under the terms of the GNU Lesser General Public License as published by
 * the Free Software Foundation, either version 3 of the License, or
 * (at your option) any later version.
 * Movalys MDK is distributed in the hope that it will be useful,
 * but WITHOUT ANY WARRANTY; without even the implied warranty of
 * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE. See the
 * GNU Lesser General Public License for more details.
 * You should have received a copy of the GNU Lesser General Public License
 * along with Movalys MDK. If not, see <http://www.gnu.org/licenses/>.
 */
package com.adeuza.movalysfwk.mf4mdd.commons.extractor;

import java.util.ArrayList;
import java.util.Collections;
import java.util.Comparator;
import java.util.List;
import java.util.Map;
import java.util.Map.Entry;

import org.apache.commons.lang3.StringUtils;
import org.dom4j.Element;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;

import com.a2a.adjava.uml.UmlModel;
import com.a2a.adjava.uml2xmodele.extractors.AbstractExtractor;
import com.a2a.adjava.uml2xmodele.extractors.PackageExtractor;
import com.a2a.adjava.xmodele.MAdapter;
import com.a2a.adjava.xmodele.MBeanScope;
import com.a2a.adjava.xmodele.MCascade;
import com.a2a.adjava.xmodele.MDaoInterface;
import com.a2a.adjava.xmodele.MDialog;
import com.a2a.adjava.xmodele.MEntityImpl;
import com.a2a.adjava.xmodele.MPackage;
import com.a2a.adjava.xmodele.MPage;
import com.a2a.adjava.xmodele.MScreen;
import com.a2a.adjava.xmodele.MViewModelImpl;
import com.a2a.adjava.xmodele.ui.component.MWorkspaceConfig;
import com.a2a.adjava.xmodele.ui.viewmodel.ViewModelType;
import com.adeuza.movalysfwk.mf4mdd.commons.xmodele.MDataLoader;
import com.adeuza.movalysfwk.mf4mdd.commons.xmodele.MDataLoaderCombo;
import com.adeuza.movalysfwk.mf4mdd.commons.xmodele.MDataLoaderInterface;
import com.adeuza.movalysfwk.mf4mdd.commons.xmodele.MDataLoaderType;
import com.adeuza.movalysfwk.mf4mdd.commons.xmodele.MFDomain;
import com.adeuza.movalysfwk.mf4mdd.commons.xmodele.MFModelDictionary;
import com.adeuza.movalysfwk.mf4mdd.commons.xmodele.MFModelFactory;
import com.adeuza.movalysfwk.mf4mdd.commons.xmodele.MFViewModel;

/**
 * Extractor for the dataloders
 * @param <XD> the domain to use
 */
public class DataLoaderExtractor<XD extends MFDomain<? extends MFModelDictionary, ? extends MFModelFactory>> extends AbstractExtractor<XD> {

	/**
	 * Logger
	 */
	private static final Logger log = LoggerFactory.getLogger(PackageExtractor.class);
	
	/**
	 * Subpackge for loader
	 */
	private static final String LOADER_SUBPACKAGE = "loader";
		
	/**
	 * stereotype
	 */
	private String syncStereotype;
	
	/**
	 * Prefix for naming interface
	 */
	private String itfNamingPrefix ;
	
	/**
	 * Suffix for naming implementation
	 */
	private String itfNamingSuffix ;
	
	/**
	 * Prefix for naming implementation
	 */
	private String implNamingPrefix ;
	
	/**
	 * Suffix for naming implementation
	 */
	private String implNamingSuffix ;
	
	/**
	 * {@inherit}
	 */
	@Override
	public void initialize(Element p_xConfig) throws Exception {
		this.syncStereotype = this.getParameters().getValue("synchronizable-stereotype", StringUtils.EMPTY);
		this.itfNamingPrefix = this.getParameters().getValue("itf-naming-prefix", StringUtils.EMPTY);
		this.itfNamingSuffix = this.getParameters().getValue("itf-naming-suffix", StringUtils.EMPTY);
		this.implNamingPrefix = this.getParameters().getValue("impl-naming-prefix", StringUtils.EMPTY);
		this.implNamingSuffix = this.getParameters().getValue("impl-naming-suffix", StringUtils.EMPTY);
	}

	/**
	 * {@inherit}
	 */
	@Override
	public void extract(UmlModel p_oModele) throws Exception {

		for (MScreen oScreen : getDomain().getDictionnary().getAllScreens()) {
			List<MPage> listPages = new ArrayList<MPage>(oScreen.getPages());
			Collections.sort(listPages,  new PageComparatorForDataLoader());
			for(MPage oPage : listPages) {
				ViewModelType oVmType = oPage.getViewModelImpl().getType();
				
				boolean bUseScreen = oScreen.isWorkspace() && oPage.getParameterValue(
						MWorkspaceConfig.PANELTYPE_PARAMETER).equals(MWorkspaceConfig.DETAIL_PANELTYPE);
							
				log.debug("page: {}, usescreen: {}, viewmodelType: {}", 
					new Object[] { oPage.getName(), bUseScreen, oVmType.name() });
				
				if ( (ViewModelType.LIST_1.equals(oVmType)
						|| ViewModelType.LIST_2.equals(oVmType)
						|| ViewModelType.LIST_3.equals(oVmType)
						|| ViewModelType.MASTER.equals(oVmType)
						) 
						&& oPage.getViewModelImpl().getEntityToUpdate() != null ) {
					this.createDataLoader(oPage, bUseScreen, oScreen);
				}
			}
		}

		for (MDialog oDialog : this.getDomain().getDictionnary().getAllDialogs()) {
			this.createDataLoader(oDialog, false, null);
		}
	}
	
	/**
	 * Compute import for dataloader
	 * @param p_oDataLoader dataloader to process
	 */
	protected void computeImports(MDataLoader p_oDataLoader) {

	}
	
	/**
	 * Compute imports for viewmodel related to dataloader
	 * @param p_oDataLoader dataloader
	 * @param p_oViewModelImpl viewmodel
	 */
	protected void computeImportsForViewModel(MDataLoader p_oDataLoader, MViewModelImpl p_oViewModelImpl) {

	}
	
	/**
	 * Compute import for dataloader after view model process
	 * @param p_oDataLoader dataloader to process
	 */
	protected void computeImportsForDataloader(MDataLoader p_oDataLoader) {

	}
	
	/**
	 * Sorts pages from their data access.
	 */
	private static class PageComparatorForDataLoader implements Comparator<MPage> {

		/**
		 * {@inheritDoc}
		 * @see java.util.Comparator#compare(java.lang.Object, java.lang.Object)
		 */
		@Override
		public int compare(MPage p_oPage1, MPage p_oPage2) {
			int i1 = 0;
			if (p_oPage1.getViewModelImpl().getPathToModel()!=null) {
				i1 = p_oPage1.getViewModelImpl().getPathToModel().split("\\.").length;
			}
			int i2 = 0;
			if (p_oPage1.getViewModelImpl().getPathToModel()!=null) {
				i2 = p_oPage1.getViewModelImpl().getPathToModel().split("\\.").length;
			}
			return i1-i2;
		}
		
	}

	/**
	 * Create or update a <code>DataLoader</code> and it interface. 
	 * @param p_oPage the page linked to this DataLoader.
	 * @param p_bUseScreenForName indicates if data loader name is computed by screen name
	 * @param p_oScreen the screen to use
	 */
	private void createDataLoader(MPage p_oPage, boolean p_bUseScreenForName, MScreen p_oScreen) {

		String sUmlName = p_oPage.getUmlName();
		if (p_bUseScreenForName) {
			sUmlName = p_oScreen.getName() + "Detail";
		}
		
		MPackage oBasePackage = getDomain().getDictionnary().getPackage(getDomain().getRootPackage());
		MPackage oLoaderPackage = oBasePackage.getChildPackage(LOADER_SUBPACKAGE);
		if (oLoaderPackage == null) {
			oLoaderPackage = new MPackage(LOADER_SUBPACKAGE, oBasePackage);
			oBasePackage.addPackage(oLoaderPackage);
		}

		MDataLoaderInterface oDataLoaderItf = this.getOrCreateDataLoaderInterface(sUmlName, p_oPage,oLoaderPackage);
		MDataLoader oDataLoader = this.createOrUpdateDataLoaderImpl(sUmlName, p_oPage, oLoaderPackage, oDataLoaderItf);
		
		this.getDomain().getDictionnary().registerDataLoader(oDataLoader);
	}

	/**
	 * Create or update an interface of a <code>DataLoader</code>.
	 * @param p_sUmlName the uml name of the DataLoader interface to create.
	 * @param p_oScreen the screen linked to this DataLoader
	 * @param p_oPackage the package of this new interface
	 * @return an <code>MDataLoaderInterface</code> object.
	 */
	private MDataLoaderInterface getOrCreateDataLoaderInterface(String p_sUmlName, MPage p_oPage, MPackage p_oPackage) {
		
		MDataLoaderInterface r_oDataLoaderItf = null;
		
		String sDataLoaderItfName;
		MViewModelImpl oVM = p_oPage.getViewModelImpl();
		MEntityImpl oEntityImpl = this.getDomain().getDictionnary().getEntityByItf(oVM.getEntityToUpdate().getMasterInterface().getFullName());

		String sDataLoaderImplName;
		if (oEntityImpl.getScope().equals(MBeanScope.APPLICATION)) {
			sDataLoaderImplName = StringUtils.join( this.implNamingPrefix, oEntityImpl.getEntityName(), this.implNamingSuffix );
		}
		else {
			sDataLoaderImplName = StringUtils.join( this.implNamingPrefix,p_sUmlName, this.implNamingSuffix );
		}
		
		
		MDataLoader oDataLoader = this.getDomain().getDictionnary().getDataLoader(sDataLoaderImplName);
		if ( oDataLoader == null) {
			
			if (oEntityImpl.getScope().equals(MBeanScope.APPLICATION)) {
				sDataLoaderItfName = StringUtils.join( this.itfNamingPrefix, oEntityImpl.getEntityName(), this.itfNamingSuffix );
			}
			else {
				sDataLoaderItfName = StringUtils.join( this.itfNamingPrefix, p_sUmlName, this.itfNamingSuffix );
			}
	
			r_oDataLoaderItf = getDomain().getXModeleFactory().createDataLoaderInterface(p_sUmlName, sDataLoaderItfName, p_oPackage);
				
			// Compute DataLoader type
			if (oVM.getType().equals(ViewModelType.LIST_1) 
					|| oVM.getType().equals(ViewModelType.LIST_2)
					|| oVM.getType().equals(ViewModelType.LIST_3)) {
				
				// synchronizable dataloader
				r_oDataLoaderItf.setSynchronizable(isSync(p_oPage.getViewModelImpl()));
				r_oDataLoaderItf.setType(MDataLoaderType.LIST);

			}
			else if(p_oPage.getParent() != null && p_oPage.getParent().isWorkspace()){
				r_oDataLoaderItf.setSynchronizable(false);
				r_oDataLoaderItf.setType(MDataLoaderType.WORKSPACE);
			}
			else {
				r_oDataLoaderItf.setSynchronizable(false);
				r_oDataLoaderItf.setType(MDataLoaderType.SINGLE);
			}
	
			r_oDataLoaderItf.setEntity(oEntityImpl);
		}
		else {
			r_oDataLoaderItf = oDataLoader.getMasterInterface();
		}
		
		return r_oDataLoaderItf;
	}

	/**
	 * Create or update an implementation of a <code>DataLoader</code> object.
	 * @param p_sUmlName the uml name of the dataLoader
	 * @param p_oScreen the screen that is link to the current dataloader
	 * @param p_oPackage the package of the dataLoader to create
	 * @param p_oDataLoaderInterface the interface of the dataloader to create or update.
	 * @return the created or updated <code>DataLoader</code>
	 */
	private MDataLoader createOrUpdateDataLoaderImpl(String p_sUmlName, MPage p_oPage, MPackage p_oPackage,MDataLoaderInterface p_oDataLoaderInterface) {

		String sDataLoaderImplName;
		if (p_oDataLoaderInterface.getEntity().getScope().equals(MBeanScope.APPLICATION)) {
			sDataLoaderImplName = StringUtils.join( this.implNamingPrefix, p_oDataLoaderInterface.getEntity().getEntityName(), this.implNamingSuffix );
		}
		else {
			sDataLoaderImplName = StringUtils.join( this.implNamingPrefix, p_sUmlName, this.implNamingSuffix);
		}
		
		MDataLoader r_oDataLoader = this.getDomain().getDictionnary().getDataLoader(sDataLoaderImplName);
		
		if ( r_oDataLoader == null ){
			
			log.debug("create dataloader : "+sDataLoaderImplName);
			r_oDataLoader = this.getDomain().getXModeleFactory()
					.createDataLoader(p_sUmlName, sDataLoaderImplName, p_oPackage, p_oDataLoaderInterface);
			
			if (p_oDataLoaderInterface.getEntity().isTransient()){
				//Mise à jour de l'objet <code>MDataLoader</code> courant pour permettre la génération d'un DataLoader pour une entité transient.
				r_oDataLoader.addImport(p_oDataLoaderInterface.getEntity().getFactory().getMasterInterface().getFullName());
				r_oDataLoader.setFactory(p_oDataLoaderInterface.getEntity().getFactory());
			}
			
			r_oDataLoader.setLoadDao(getDomain().getDictionnary().getDaoItfByEntityItf(
				p_oDataLoaderInterface.getEntity().getMasterInterface().getFullName()));
			
			this.computeImports(r_oDataLoader);
		}
		else {
			log.debug("Use existing dataloader :" + sDataLoaderImplName);
		}

		MViewModelImpl oVM = p_oPage.getViewModelImpl();
		this.computeLoadCascade(oVM, r_oDataLoader);
		this.computeObservedEntities(r_oDataLoader);
		this.computeComboImpl(p_oPage, r_oDataLoader);
		this.addDataLoaderToViewModel(p_oPage.getViewModelImpl(), r_oDataLoader);
	
		this.computeImportsForDataloader(r_oDataLoader);
		
		return r_oDataLoader;
	}


	/**
	 * Add data loader to viewmodel
	 * @param p_oPage
	 * @param p_oDataLoaderInterface
	 * @param p_oDataLoader
	 */
	private void addDataLoaderToViewModel(MViewModelImpl p_oMViewModelImpl, MDataLoader p_oDataLoader) {
		// Add dataLoader to viewmodel
		MFViewModel oViewModel = (MFViewModel) p_oMViewModelImpl;
		oViewModel.setDataLoader(p_oDataLoader);
		oViewModel.addImport(p_oDataLoader.getMasterInterface().getFullName());
		this.computeImportsForViewModel(p_oDataLoader, p_oMViewModelImpl);
	}
	
	/**
	 * Create and add combo implementation in the <code>MDataLoader</code> send as parameter.
	 * @param p_oPage the page linked to this combo
	 * @param p_oMDataLoader the implementation of the DataLoader where we whant to push the combo.
	 */
	private void computeComboImpl(MPage p_oPage, MDataLoader p_oMDataLoader){
		
		Map<String,MAdapter> oExternalAdapters=p_oPage.getExternalAdapters();
		for (Entry<String,MAdapter> oEntry : oExternalAdapters.entrySet()){
			
			MAdapter oAdapter = oEntry.getValue();
			
			//cas d'une combo simple ou multiple
			if ((oAdapter.getViewModel().getType().equals(ViewModelType.LIST_1__ONE_SELECTED)
					|| oAdapter.getViewModel().getType().equals(ViewModelType.LIST_1__N_SELECTED))
					&& oAdapter.getViewModel().getEntityToUpdate() != null){
				
				MDaoInterface oDao = null;
				MDataLoaderCombo oCurrentCombo = null;
				if (!oAdapter.getViewModel().getEntityToUpdate().isTransient()) {
					oDao = getDomain().getDictionnary().getDaoItfByEntityItf(oAdapter.getViewModel().getEntityToUpdate().getMasterInterface().getFullName());
					oCurrentCombo = p_oMDataLoader.getMasterInterface().getCombo(oDao, oAdapter.getViewModel());
				}
				
				if ( oCurrentCombo == null ){
					
					//create a new combo
					oCurrentCombo = new MDataLoaderCombo();
					oCurrentCombo.setEntityViewModel(oAdapter.getViewModel());
					if (oDao != null) {
						oCurrentCombo.setEntityDao(oDao);
					}
					
					//imports pour l'implémentation
					p_oMDataLoader.addImport(oAdapter.getViewModel().getEntityToUpdate().getMasterInterface().getFullName());
					if (oDao != null) {
						p_oMDataLoader.addImport(oDao.getMEntityImpl().getFullName());
						p_oMDataLoader.addImport(oDao.getFullName());
					}
					p_oMDataLoader.addImport(List.class.getName());
					
					//imports pour l'interface
					p_oMDataLoader.getMasterInterface().addImport(List.class.getName());
					p_oMDataLoader.getMasterInterface().addImport(oAdapter.getViewModel().getEntityToUpdate().getMasterInterface().getFullName());
					
					p_oMDataLoader.getMasterInterface().addCombo(oCurrentCombo);
				}
				
				//ajout des cascades sur la combo courante
				this.computeLoadCascadeForCombo(oAdapter.getViewModel(), p_oMDataLoader, oCurrentCombo);
			}
		}
	}
	
	/**
	 * Compute/Add some needed cascade.
	 * @param p_oVM the ViewModel to scan
	 * @param r_oMDataLoader the dataloader to populate.
	 */
	private void computeLoadCascade(MViewModelImpl p_oVM, MDataLoader p_oMDataLoader) {
		p_oMDataLoader.addLoadCascade(p_oVM.getLoadCascades());
		p_oMDataLoader.addImports(p_oVM.getImportCascades());
		for (MViewModelImpl oSubVm : p_oVM.getSubViewModels()) {
			this.computeLoadCascade(oSubVm, p_oMDataLoader);
		}
	}
	
	/**
	 * Compute/add somme needed cascade for the combo send as parameter.
	 * @param p_oVM the ViewModel to scan
	 * @param p_oMDataLoader the dataloader to populate
	 * @param p_oMDataLoaderCombo the added combo
	 */
	private void computeLoadCascadeForCombo(MViewModelImpl p_oVM, MDataLoader p_oMDataLoader, MDataLoaderCombo p_oMDataLoaderCombo) {
		p_oMDataLoaderCombo.addCascadeToCombo(p_oVM.getLoadCascades());
		p_oMDataLoader.addImports(p_oVM.getImportCascades());
		for (MViewModelImpl oSubVm : p_oVM.getSubViewModels()) {
			this.computeLoadCascadeForCombo(oSubVm, p_oMDataLoader, p_oMDataLoaderCombo);
		}
	}

	/**
	 * computes observed entities
	 * @param p_oMDataLoader dataloader to process
	 */
	private void computeObservedEntities(MDataLoader p_oMDataLoader) {
		if (p_oMDataLoader.getMasterInterface().isSynchronizable()) {
			for (MCascade oCascade : p_oMDataLoader.getLoadCascade()) {
				if (oCascade.getTargetEntity().hasStereotype(this.syncStereotype)) {
					p_oMDataLoader.addObservedEntity(oCascade.getTargetEntity().getMasterInterface());
				}
			}
		}
	}

	/**
	 * @param p_oVM
	 * @param r_oMDataLoader dataloader to process
	 */
	private boolean isSync(MViewModelImpl p_oVM) {
		boolean r_bSynchronizable = false;
		if (p_oVM.getLoadCascades() != null) {
			for (MCascade oCascade : p_oVM.getLoadCascades()) {
				if (oCascade.getTargetEntity().hasStereotype(this.syncStereotype)) {
					r_bSynchronizable = true;
					break;
				}
			}
		}
		if (!r_bSynchronizable) {
			for (MViewModelImpl oSubVm : p_oVM.getSubViewModels()) {
				if (isSync(oSubVm)) {
					r_bSynchronizable = true;
					break;
				}
			}
		}
		return r_bSynchronizable;
	}
}
