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
package com.adeuza.movalysfwk.mf4mdd.ios.generators;

import java.util.ArrayList;
import java.util.List;

import javax.xml.bind.annotation.XmlElementWrapper;

import org.dom4j.Document;
import org.dom4j.DocumentHelper;
import org.dom4j.Element;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;

import com.a2a.adjava.generator.core.incremental.AbstractIncrementalGenerator;
import com.a2a.adjava.generator.core.incremental.NonGeneratedBlocExtractor;
import com.a2a.adjava.generators.DomainGeneratorContext;
import com.a2a.adjava.utils.Chrono;
import com.a2a.adjava.utils.FileTypeUtils;
import com.a2a.adjava.xmodele.IDomain;
import com.a2a.adjava.xmodele.IModelDictionary;
import com.a2a.adjava.xmodele.IModelFactory;
import com.a2a.adjava.xmodele.MAction;
import com.a2a.adjava.xmodele.MActionType;
import com.a2a.adjava.xmodele.MViewModelImpl;
import com.a2a.adjava.xmodele.SElement;
import com.a2a.adjava.xmodele.XProject;
import com.a2a.adjava.xmodele.ui.viewmodel.ViewModelType;
import com.adeuza.movalysfwk.mf4mdd.commons.xmodele.MDataLoader;
import com.adeuza.movalysfwk.mf4mdd.ios.xmodele.MF4IDictionnary;

public class MF4ITyphoonAssemblyGenerator extends  AbstractIncrementalGenerator<IDomain<IModelDictionary,IModelFactory>> {

	/**
	 * Package of viewmodel creator
	 */
	private static final String TYPHOONASSEMBLY_PACKAGE = "beansfactory";

	/**
	 * Package of viewmodel creator
	 */
	private static final String TYPHOONASSEMBLY_FILENAME = "MFProjectGeneratedComponentsAssembly";

	/**
	 * Logger
	 */
	private static final Logger log = LoggerFactory.getLogger(MF4IViewModelCreatorGenerator.class);


	/**
	 * {@inheritDoc}
	 * @see com.a2a.adjava.generators.ResourceGenerator#genere(com.a2a.adjava.xmodele.XProject, com.a2a.adjava.generators.DomainGeneratorContext)
	 */
	@Override
	public void genere(XProject<IDomain<IModelDictionary,IModelFactory>> p_oProject, DomainGeneratorContext p_oContext) throws Exception {
		log.debug("> TyphoonAssemblyGenerator.genere");
		Chrono oChrono = new Chrono(true);
		NonGeneratedBlocExtractor oNonGeneratedBlocExtractor = new NonGeneratedBlocExtractor();

		this.createTyphoonAssembly(oNonGeneratedBlocExtractor, p_oProject, p_oContext);
		log.debug("< TyphoonAssemblyGenerator.genere: {}", oChrono.stopAndDisplay());		
	}


	/**
	 * Generation of the viewmodel creator
	 * @param p_oNonGeneratedBlocExtractor bloc extractor
	 * @param p_oProject project
	 * @param p_oContext context
	 * @throws Exception
	 */
	private void createTyphoonAssembly(NonGeneratedBlocExtractor p_oNonGeneratedBlocExtractor,
			XProject<IDomain<IModelDictionary,IModelFactory>> p_oProject, DomainGeneratorContext p_oContext) throws Exception {
		TyphoonConfig oTyphoonConfiguration = this.computeTyphoonConfiguration(p_oProject);
		if (oTyphoonConfiguration != null) {			
			this.createTyphoonAssemblyInterface( oTyphoonConfiguration, p_oProject, p_oContext);
			this.createTyphoonAssemblyImpl( oTyphoonConfiguration, p_oProject, p_oContext);
		}
	}


	private void createTyphoonAssemblyInterface( TyphoonConfig p_oTyphoonConfiguration, XProject<IDomain<IModelDictionary,IModelFactory>> p_oProject, DomainGeneratorContext p_oContext ) throws Exception {
		Element r_xAssemblyFile = DocumentHelper.createElement("master-typhoonassembly");		
		r_xAssemblyFile.add(p_oTyphoonConfiguration.toXml());
		Document xAssembyDoc = DocumentHelper.createDocument(r_xAssemblyFile);
		Element rootElement = xAssembyDoc.getRootElement();
		rootElement.addAttribute("main-project", p_oProject.getDomain().getGlobalParameters().get("mainProject"));

		String sTyphoonAssemblyFile = FileTypeUtils.computeFilenameForIOSInterface(TYPHOONASSEMBLY_PACKAGE, TYPHOONASSEMBLY_FILENAME, p_oProject.getSourceDir());
		log.debug("  generation du fichier {}", sTyphoonAssemblyFile);
		this.doIncrementalTransform("beanassembly-interface.xsl", sTyphoonAssemblyFile, xAssembyDoc, p_oProject, p_oContext);	
	}

	private void createTyphoonAssemblyImpl( TyphoonConfig p_oTyphoonConfiguration, XProject<IDomain<IModelDictionary,IModelFactory>> p_oProject, DomainGeneratorContext p_oContext ) throws Exception {
		Element r_xAssemblyFile = DocumentHelper.createElement("master-typhoonassembly");		
		r_xAssemblyFile.add(p_oTyphoonConfiguration.toXml());
		Document xAssembyDoc = DocumentHelper.createDocument(r_xAssemblyFile);
		Element rootElement = xAssembyDoc.getRootElement();
		rootElement.addAttribute("main-project", p_oProject.getDomain().getGlobalParameters().get("mainProject"));

		String sTyphoonAssemblyFile = FileTypeUtils.computeFilenameForIOSImpl(TYPHOONASSEMBLY_PACKAGE, TYPHOONASSEMBLY_FILENAME, p_oProject.getSourceDir());
		log.debug("  generation du fichier {}", sTyphoonAssemblyFile);
		this.doIncrementalTransform("beanassembly-impl.xsl", sTyphoonAssemblyFile, xAssembyDoc, p_oProject, p_oContext);	
	}

	private TyphoonConfig computeTyphoonConfiguration(XProject<IDomain<IModelDictionary,IModelFactory>> p_oMProject) {
		TyphoonConfig oTyphoonConfig = new TyphoonConfig();

		// Components for viewmodel
		for( MViewModelImpl oViewModel : p_oMProject.getDomain().getDictionnary().getAllViewModels()) {
			TyphoonComponent oTyphoonComponent = new TyphoonComponent();
			oTyphoonComponent.setClassName(oViewModel.getName());
			oTyphoonComponent.setKey(oViewModel.getMasterInterface().getName());
			oTyphoonComponent.setCategory("viewmodel");

			//Cas des Views models simples : ce sont des prototypes
			if (oViewModel.getType().equals(ViewModelType.LISTITEM_1) 
					|| oViewModel.getType().equals(ViewModelType.FIXED_LIST)
					|| oViewModel.getType().equals(ViewModelType.LISTITEM_2) 
					|| oViewModel.getType().equals(ViewModelType.LISTITEM_3)
					|| oViewModel.getType().equals(ViewModelType.FIXED_LIST_ITEM) ) {
				oTyphoonComponent.setScope(TyphoonScope.prototype);
			}

			//Cas des ListViewModels imbriqués dans une liste 2D/3D seulement : 
			//ce sont également des prototypes
			if( (oViewModel.getType().equals(ViewModelType.LIST_1) 
					&& oViewModel.getParent() != null 
					&& oViewModel.getParent().getType().equals(ViewModelType.LISTITEM_2)) ||
					(oViewModel.getType().equals(ViewModelType.LIST_2) 
							&& oViewModel.getParent() != null 
							&& oViewModel.getParent().getType().equals(ViewModelType.LISTITEM_3)) ) {
				oTyphoonComponent.setScope(TyphoonScope.prototype);
			}

			oTyphoonConfig.addComponent(oTyphoonComponent);
		}

		// Components for dataloader
		for( MDataLoader oDataLoader : ((MF4IDictionnary) p_oMProject.getDomain().getDictionnary()).getAllDataLoaders()) {
			TyphoonComponent oTyphoonComponent = new TyphoonComponent();
			oTyphoonComponent.setClassName(oDataLoader.getName());
			oTyphoonComponent.setKey(oDataLoader.getMasterInterface().getName());
			oTyphoonComponent.setCategory("dataloader");
			oTyphoonConfig.addComponent(oTyphoonComponent);
		}

		// Components for actions
		for( MAction oAction : p_oMProject.getDomain().getDictionnary().getAllActions()) {
			if ( oAction.getType().equals(MActionType.SAVEDETAIL) || 
					oAction.getType().equals(MActionType.DELETEDETAIL)) {
				TyphoonComponent oTyphoonComponent = new TyphoonComponent();
				oTyphoonComponent.setClassName(oAction.getName());
				oTyphoonComponent.setKey(oAction.getMasterInterface().getName());
				oTyphoonComponent.setCategory("action");
				oTyphoonComponent.setScope(TyphoonScope.prototype);
				oTyphoonConfig.addComponent(oTyphoonComponent);
			}
		}

		return oTyphoonConfig;
	}

	/**
	 * Typhoon configuration
	 * @author lmichenaud
	 *
	 */
	
	private static class TyphoonConfig extends SElement{

		public TyphoonConfig() {
			super("typhoon-config",null);
		}
		/**
		 * Components
		 */
		@XmlElementWrapper(name="components")
		private List<TyphoonComponent> components = new ArrayList<TyphoonComponent>();

		/**
		 * Get components
		 * @return components
		 */
		public List<TyphoonComponent> getComponents() {
			return this.components;
		}

		/** 
		 * Converted the element to xml
		 * @return the xml representation of element
		 */
		public Element toXml() {
			Element r_xElem = super.toXml();
			r_xElem.addElement("name").setText(TYPHOONASSEMBLY_FILENAME);
			for(TyphoonComponent oTyphoonCompoent : this.components) {
				Element oTyphoonComponentElement = oTyphoonCompoent.toXml();
				r_xElem.addElement("component").add(oTyphoonComponentElement);
			}
			return r_xElem;
		}
		/**
		 * @param p_oTyphoonComponent
		 */
		public void addComponent( TyphoonComponent p_oTyphoonComponent ) {
			this.components.add(p_oTyphoonComponent);
		}
	}

	/**
	 * @author lmichenaud
	 *
	 */	
	private static class TyphoonComponent extends SElement{

		public TyphoonComponent() {
			super("config",null);		
		}
		
		/**
		 * Class name
		 */
		private String className ;

		/**
		 * Key
		 */
		private String key ;

		/**
		 * Category
		 */
		private String category ;

		/**
		 * Scope of component
		 */
		private TyphoonScope scope = TyphoonScope.singleton;

		/**
		 * Get class name
		 * @return class name
		 */
		public String getClassName() {
			return this.className;
		}

		/**
		 * Set class name
		 * @param p_sClassName class name
		 */
		public void setClassName(String p_sClassName) {
			this.className = p_sClassName;
		}

		/**
		 * Get key
		 * @return key
		 */
		public String getKey() {
			return this.key;
		}

		/**
		 * Set key
		 * @param p_sKey key
		 */
		public void setKey(String p_sKey) {
			this.key = p_sKey;
		}

		/**
		 * Get category
		 * @return category
		 */
		public String getCategory() {
			return this.category;
		}

		/**
		 * Set category
		 * @param p_sCategory category
		 */
		public void setCategory(String p_sCategory) {
			this.category = p_sCategory;
		}

		/**
		 * Get scope
		 * @return scope
		 */
		public TyphoonScope getScope() {
			return this.scope;
		}

		/**
		 * Set scope
		 * @param p_oScope scope
		 */
		public void setScope(TyphoonScope p_oScope) {
			this.scope = p_oScope;
		}

		@Override
		public Element toXml() {
			Element r_xElem = super.toXml();
			r_xElem.addElement("class").setText(getClassName());
			r_xElem.addElement("key").setText(getKey());
			r_xElem.addElement("scope").setText((getScope() == TyphoonScope.singleton) ? "singleton" : "prototype");
			return r_xElem;
		}
	}

	/**
	 * Scope of typhoon component
	 * @author lmichenaud
	 *
	 */
	private enum TyphoonScope {

		/**
		 * Singleton
		 */
		singleton,

		/**
		 * 
		 */
		prototype ;
	}

}
