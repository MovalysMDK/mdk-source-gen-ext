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
package com.adeuza.movalysfwk.mf4mdd.mbandroid.extractors;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;

import com.a2a.adjava.languages.java.JavaTypes;
import com.a2a.adjava.xmodele.MLinkedInterface;
import com.a2a.adjava.xmodele.MViewModelImpl;
import com.adeuza.movalysfwk.mf4mdd.commons.extractor.DataLoaderExtractor;
import com.adeuza.movalysfwk.mf4mdd.commons.xmodele.MDataLoader;
import com.adeuza.movalysfwk.mf4mdd.commons.xmodele.MDataLoaderCombo;
import com.adeuza.movalysfwk.mf4mdd.commons.xmodele.MDataLoaderType;
import com.adeuza.movalysfwk.mf4mdd.commons.xmodele.MFDomain;
import com.adeuza.movalysfwk.mf4mdd.commons.xmodele.MFModelDictionary;
import com.adeuza.movalysfwk.mf4mdd.commons.xmodele.MFModelFactory;

/**
 * Extractor for the dataloaders 
 */
public class MF4ADataLoaderExtractor extends DataLoaderExtractor<MFDomain<MFModelDictionary,MFModelFactory>> {

	/**
	 * Logger
	 */
	private static final Logger log = LoggerFactory.getLogger(MF4ADataLoaderExtractor.class);
	
	/**
	 * {@inheritDoc}
	 */
	@Override
	protected void computeImports(MDataLoader p_oDataLoader) {
		p_oDataLoader.addImport(MF4ATypes.DataloaderException.getImport());
		p_oDataLoader.addImport(MF4ATypes.MContext.getImport());
		p_oDataLoader.addImport(MF4ATypes.CascadeSet.getImport());
		p_oDataLoader.addImport(MF4ATypes.BeanLoader.getImport());
		p_oDataLoader.addImport(MF4ATypes.DaoException.getImport());
		p_oDataLoader.addImport(MF4ATypes.DataloaderParts.getImport());
		p_oDataLoader.getMasterInterface().addImport(MF4ATypes.DataloaderParts.getImport());

		if (p_oDataLoader.getMasterInterface().getEntity().isTransient()){
			p_oDataLoader.addImport(p_oDataLoader.getMasterInterface().getEntity().getFactory().getMasterInterface().getFullName());
		}

		if ( p_oDataLoader.getMasterInterface().getType().equals(MDataLoaderType.LIST)) {
			
			p_oDataLoader.addImport(JavaTypes.List.getImport());
			
			if ( p_oDataLoader.getMasterInterface().isSynchronizable()) {
				p_oDataLoader.addImport(MF4ATypes.AbstractSynchronisableListDataloader.getImport());
				p_oDataLoader.addImport(MF4ATypes.SynchronisationResponseTreatmentInformation.getImport());
				
				p_oDataLoader.getMasterInterface().addImport(MF4ATypes.SynchronisableListDataloader.getImport());
			}
			else {
				p_oDataLoader.addImport(MF4ATypes.AbstractListDataloader.getImport());
				p_oDataLoader.getMasterInterface().addImport(MF4ATypes.ListDataloader.getImport());
			}
		}
		else {
			p_oDataLoader.getMasterInterface().addImport(MF4ATypes.MMDataloader.getImport());

			if ( p_oDataLoader.getMasterInterface().isSynchronizable()) {
				p_oDataLoader.addImport(MF4ATypes.AbstractSynchronisableDataLoader.getImport());	
			}
			else {
				p_oDataLoader.addImport(MF4ATypes.AbstractDataloader.getImport());	
			}
		}
	}

	/**
	 * {@inheritDoc}
	 * @see com.adeuza.movalysfwk.mf4mdd.commons.extractor.DataLoaderExtractor#computeImportsForViewModel(com.adeuza.movalysfwk.mf4mdd.mbandroid.xmodele.MDataLoader, com.a2a.adjava.xmodele.MViewModelImpl)
	 */
	@Override
	protected void computeImportsForViewModel(MDataLoader p_oDataLoader,
			MViewModelImpl p_oViewModelImpl) {
		super.computeImportsForViewModel(p_oDataLoader, p_oViewModelImpl);
		p_oViewModelImpl.addImport( MF4ATypes.Dataloader.getImport());
		p_oViewModelImpl.getMasterInterface().addImport( MF4ATypes.Dataloader.getImport());
		p_oViewModelImpl.getMasterInterface().addLinkedInterface(new MLinkedInterface("UpdatableFromDataloader", 
					MF4ATypes.UpdatableFromDataloader.getImport()));
	}
	
	/**
	 * {@inheritDoc}
	 */
	protected void computeImportsForDataloader(MDataLoader p_oDataLoader) {
		// on importe la classe DaoException que si le dataloader ne porte pas sur une entité transiente et que les entités liées ont des dao 
		boolean bImportDao = !p_oDataLoader.getMasterInterface().getEntity().isTransient(); 
		
		for (MDataLoaderCombo oCombo : p_oDataLoader.getMasterInterface().getCombos()) {
			bImportDao = bImportDao || oCombo.getEntityDao() != null;
		}
		
		if (bImportDao) {
			p_oDataLoader.addImport(MF4ATypes.DaoException.getImport());
		}
	}
}
