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
package com.adeuza.movalysfwk.mf4mdd.ios.extractor;

import java.util.ArrayList;
import java.util.List;

import org.apache.commons.lang3.StringUtils;
import org.dom4j.Element;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;

import com.a2a.adjava.uml.UmlModel;
import com.a2a.adjava.uml2xmodele.extractors.AbstractExtractor;
import com.a2a.adjava.uml2xmodele.extractors.viewmodel.MViewModelFactory;
import com.a2a.adjava.xmodele.IDomain;
import com.a2a.adjava.xmodele.IModelDictionary;
import com.a2a.adjava.xmodele.IModelFactory;
import com.a2a.adjava.xmodele.MEntityImpl;
import com.a2a.adjava.xmodele.MPackage;
import com.a2a.adjava.xmodele.MViewModelImpl;
import com.a2a.adjava.xmodele.ui.viewmodel.ViewModelType;
import com.a2a.adjava.xmodele.ui.viewmodel.mappings.IVMMappingDesc;
import com.a2a.adjava.xmodele.ui.viewmodel.mappings.MMappingAttribute;
import com.a2a.adjava.xmodele.ui.viewmodel.mappings.MMappingType;

/**
 * List2D/3D extractor for iOS
 * @author qlagarde
 *
 */
public class MF4ExpandableListExtractor extends AbstractExtractor<IDomain<IModelDictionary,IModelFactory>> {

	/** Logger */
	private static final Logger log = LoggerFactory.getLogger(MViewModelFactory.class);

	/**
	 * View model prefix key
	 */
	private static String PARAMETER_VIEWMODEL_PREFIX_KEY = "viewmodel-prefix";
	
	/**
	 * view model list identifier key 
	 */
	private static String PARAMETER_VIEWMODEL_LIST_IDENTIFIER_KEY = "viewmodel-list-identifier";
	
	/**
	 * View model has sublist key
	 */
	private static String PARAMETER_VIEWMODEL_HAS_SUBLIST_KEY = "viewmodel-has-sublist-key";
	
	/**
	 * list entity name prefix
	 */
	private static String PARAMETER_MAPPING_LIST_ENTITY_NAME_PREFIX = "mapping-list-entity-name-prefix";
	
	/**
	 * list entity name suffix
	 */
	private static String PARAMETER_MAPPING_LIST_ENTITY_NAME_SUFFIX = "mapping-list-entity-name-suffix";

	
	/**
	 * {@inheritDoc}
	 * @see com.a2a.adjava.languages.ios.extractors.StoryBoardExtractor#getLabelType()
	 */
	@Override
	public void initialize(Element p_xConfig) throws Exception {
		// nothing to do
	}

	/**
	 * {@inheritDoc}
	 * @see com.a2a.adjava.languages.ios.extractors.StoryBoardExtractor#getLabelType()
	 */
	@Override
	public void extract(UmlModel p_oModele) throws Exception {
		// Create storyboards from screens
		
		//Copie de la liste des viewModels pour ne pas provoquer des accès concurrents 
		//(modification du dictionnaire pendant qu'on itère sur les VM
		List<MViewModelImpl> oViewModelsListCopy = new ArrayList<>();
		for( MViewModelImpl oViewModel : this.getDomain().getDictionnary().getAllViewModels()) {
			oViewModelsListCopy.add(oViewModel);
		}
		
		for( MViewModelImpl oViewModel : oViewModelsListCopy) {
			if(oViewModel.getType() == ViewModelType.LISTITEM_2 )
			{
				fixListItem2ViewModelReference(oViewModel);
			}
		}
	}

	/**
	 * Fixes the references between ViewModel for 2D Lists
	 * @param p_oListItem2ViewModel the view model to use
	 */
	private void fixListItem2ViewModelReference(MViewModelImpl p_oListItem2ViewModel) {


		MViewModelImpl oListItem1ViewModel = null;
		List<MViewModelImpl> oSubViewModels = p_oListItem2ViewModel.getSubViewModels();
		for(MViewModelImpl oViewModel : p_oListItem2ViewModel.getSubViewModels()) {

			//Mauvaise référence => on la supprime
			if(oViewModel.getType() == ViewModelType.LISTITEM_1) {
				oListItem1ViewModel = oViewModel;
				oSubViewModels.remove(oViewModel);
				
				//Création du nouveau ViewModel de type LIST_1
				MViewModelImpl oNewList1ViewModel = this.createList1ViewModel(p_oListItem2ViewModel, oListItem1ViewModel);
				oNewList1ViewModel.getSubViewModels().add(oListItem1ViewModel);
				oNewList1ViewModel.addParent(p_oListItem2ViewModel);
				
				// create list viewmodel interface
				MViewModelFactory.getInstance().createListViewModelInterface(oNewList1ViewModel, oListItem1ViewModel, this.getDomain());

				//enregistrement du viewmodel list
				log.debug("  register viewmodel list : {}", oNewList1ViewModel.getFullName());
				getDomain().getDictionnary().registerViewModel(oNewList1ViewModel);
				getDomain().getDictionnary().registerViewModelInterface(oNewList1ViewModel.getMasterInterface());

				//Ajout de la nouvelle référence.
				oSubViewModels.add(oNewList1ViewModel);
				p_oListItem2ViewModel.addParameter(this.getParameterValue(PARAMETER_VIEWMODEL_HAS_SUBLIST_KEY), 
						String.valueOf(true));
			
				//Mise à jour du mapping
				IVMMappingDesc oListItem2ViewModelMappingMainEntity = p_oListItem2ViewModel.getMapping();
				
				String sOldEntityAttributeName = StringUtils.join(this.getParameterValue(PARAMETER_MAPPING_LIST_ENTITY_NAME_PREFIX), 
						oViewModel.getName(), 
						this.getParameterValue(PARAMETER_MAPPING_LIST_ENTITY_NAME_SUFFIX));
				
				String sNewEntityAttributeName = StringUtils.join(this.getParameterValue(PARAMETER_MAPPING_LIST_ENTITY_NAME_PREFIX),
						this.getParameterValue(PARAMETER_VIEWMODEL_LIST_IDENTIFIER_KEY),
						oViewModel.getName(),
						this.getParameterValue(PARAMETER_MAPPING_LIST_ENTITY_NAME_SUFFIX));
				
				MMappingAttribute oMMappingAttr = oListItem2ViewModelMappingMainEntity.getMapAttributes().get(sOldEntityAttributeName);
				
				oListItem2ViewModelMappingMainEntity.removeEntityOrAttribute(sOldEntityAttributeName);
				oListItem2ViewModelMappingMainEntity.addEntity(oNewList1ViewModel,
						oViewModel.getEntityToUpdate(),
						oMMappingAttr.getGetter(),
						sNewEntityAttributeName,
						MMappingType.vmlist,
						false,
						getDomain(), null);
				
				break;
			}
		}
	}


	/**
	 * Creates a new ViewModel from its item.
	 * @param p_oParentViewModel The parent ViewModel of the new created ViewModel
	 * @param p_oItemViewModel The ViewModel that will be an item of this new List ViewModel
	 * @return The new ViewModel of type LIST_1
	 */
	private MViewModelImpl createList1ViewModel(MViewModelImpl p_oParentViewModel, MViewModelImpl p_oItemViewModel) {
		//Récupération des paramètres de l'extracteur
		String sViewModelPrefix = this.getParameterValue(PARAMETER_VIEWMODEL_PREFIX_KEY);
		String sListViewModelIdentifier = this.getParameterValue(PARAMETER_VIEWMODEL_LIST_IDENTIFIER_KEY);

		String sNewViewModelName = p_oItemViewModel.getName().replace(sViewModelPrefix, StringUtils.join(sViewModelPrefix, sListViewModelIdentifier));	
		String sNewViewModelUmlName = StringUtils.join(p_oParentViewModel.getUmlName(), p_oItemViewModel.getUmlName());
		MPackage oNewViewModelPackage = p_oItemViewModel.getPackage();
		ViewModelType iNewViewModelType = ViewModelType.LIST_1;
		MEntityImpl oNewViewModelEntityToUpdate = p_oParentViewModel.getEntityToUpdate();
		boolean bNewViewModelCustomizable = false;

		//Création du new ViewModel
		return this.getDomain().getXModeleFactory().createViewModel(sNewViewModelName, sNewViewModelUmlName, oNewViewModelPackage, iNewViewModelType, oNewViewModelEntityToUpdate, null, bNewViewModelCustomizable);
	}
}
